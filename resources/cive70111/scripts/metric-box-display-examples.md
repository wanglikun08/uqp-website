# MetricBoxDisplay - Usage Examples

The `metric-box-display.js` utility provides a standardized, reusable component for metric display boxes with MathJax rendering, custom colors, and optional labels.

## Basic Setup

### 1. Include the script in your HTML

```html
<script src="../scripts/metric-box-display.js"></script>
<script src="script.js"></script>
```

### 2. HTML Structure

Simple `.equation` boxes with just IDs (no custom CSS classes needed):

```html
<!-- Basic MSE box -->
<div class="equation" id="mse">
    MSE = 0.0
</div>

<!-- Training set MSE -->
<div class="equation" id="train-mse">
    MSE = 0.0
</div>

<!-- Test set MSE -->
<div class="equation" id="test-mse">
    MSE = 0.0
</div>

<!-- MAE box -->
<div class="equation" id="mae">
    MAE = 0.0
</div>
```

### 3. No CSS Required!

Colors are set via JavaScript - no need for demo-specific CSS classes. The base `.equation` class from `demo-common.css` provides the structure.

## Usage Examples

### Example 1: Single MSE Box (like lec02a)

```javascript
// Initialize with purple theme and label
const mseDisplay = new MetricBoxDisplay('mse', 'MSE', {
    background: '#f3e5f5',
    color: '#7b1fa2',
    border: '#e1bee7',
    borderLeft: '#9c27b0',
    label: 'Mean Squared Error',
    decimals: 2
});

// Update the display with a numeric value
function updateMetrics() {
    const mse = calculateMSE(yTrue, yPred);
    mseDisplay.update(mse);
}

// Show placeholder when no data available
mseDisplay.update(null);  // Shows "MSE = ?"
// or
mseDisplay.update('?');   // Also shows "MSE = ?"
```

### Example 2: Dual MSE Boxes (like lec03d)

```javascript
// Initialize displays with different colors
const displays = {
    trainMse: new MetricBoxDisplay('train-mse', 'MSE', {
        background: '#e3f2fd',
        color: '#1976d2',
        border: '#bbdefb',
        borderLeft: '#2196f3',
        label: 'Training Set',
        decimals: 1
    }),
    testMse: new MetricBoxDisplay('test-mse', 'MSE', {
        background: '#fff3e0',
        color: '#f57c00',
        border: '#ffe0b2',
        borderLeft: '#ff9800',
        label: 'Test Set',
        decimals: 1
    })
};

// Batch update (more efficient)
function updateMetrics() {
    const trainMSE = calculateMSE(trainY, trainPred);
    const testMSE = calculateMSE(testY, testPred);

    MetricBoxDisplay.batchUpdate([
        { display: displays.trainMse, value: trainMSE },
        { display: displays.testMse, value: testMSE }
    ]);
}
```

### Example 3: Multiple Metrics with Different Colors

```javascript
const displays = {
    mse: new MetricBoxDisplay('mse', 'MSE', {
        background: '#f3e5f5',
        color: '#7b1fa2',
        border: '#e1bee7',
        borderLeft: '#9c27b0',
        label: 'Mean Squared Error',
        decimals: 2
    }),
    mae: new MetricBoxDisplay('mae', 'MAE', {
        background: '#e8f5e8',
        color: '#2e7d32',
        border: '#c8e6c9',
        borderLeft: '#4caf50',
        label: 'Mean Absolute Error',
        decimals: 2
    }),
    r2: new MetricBoxDisplay('r2', 'R²', {
        background: '#e3f2fd',
        color: '#1565c0',
        border: '#bbdefb',
        borderLeft: '#1976d2',
        decimals: 3
    })
};

function updateMetrics() {
    const mse = calculateMSE(yTrue, yPred);
    const mae = calculateMAE(yTrue, yPred);
    const r2 = calculateR2(yTrue, yPred);

    MetricBoxDisplay.batchUpdate([
        { display: displays.mse, value: mse },
        { display: displays.mae, value: mae },
        { display: displays.r2, value: r2 }
    ]);
}
```

### Example 4: Custom Metric Names

```javascript
// Loss display
const lossDisplay = new MetricBoxDisplay('loss', 'Loss', {
    background: '#ffebee',
    color: '#c62828',
    border: '#ffcdd2',
    borderLeft: '#d32f2f',
    label: 'Cross-Entropy',
    decimals: 4
});

// Accuracy display (no label)
const accDisplay = new MetricBoxDisplay('accuracy', 'Accuracy', {
    background: '#e8f5e9',
    color: '#2e7d32',
    border: '#c8e6c9',
    borderLeft: '#43a047',
    decimals: 1
});

// Update
lossDisplay.update(0.1234);
accDisplay.update(95.6);
```

### Example 5: Coordinated Update with Equation

When updating metrics alongside MathJax equations:

```javascript
function updateMetrics() {
    const trainMSE = calculateMSE(trainY, trainPred);
    const testMSE = calculateMSE(testY, testPred);

    // Update equation
    const equationEl = document.getElementById('equation');
    equationEl.innerHTML = '$y = \\beta_0 + \\beta_1 x$';

    // Update displays without triggering MathJax individually
    displays.trainMse.update(trainMSE, false);
    displays.testMse.update(testMSE, false);

    // Single MathJax render for all elements
    if (window.MathJax) {
        MathJax.typesetPromise([
            equationEl,
            displays.trainMse.element,
            displays.testMse.element
        ]).catch((err) => console.log('MathJax error:', err));
    }
}
```

## Standard Color Themes

Here are the standard color themes used across demos:

### Purple (MSE default)
```javascript
{
    background: '#f3e5f5',
    color: '#7b1fa2',
    border: '#e1bee7',
    borderLeft: '#9c27b0'
}
```

### Blue (Training Set)
```javascript
{
    background: '#e3f2fd',
    color: '#1976d2',
    border: '#bbdefb',
    borderLeft: '#2196f3'
}
```

### Orange (Test Set)
```javascript
{
    background: '#fff3e0',
    color: '#f57c00',
    border: '#ffe0b2',
    borderLeft: '#ff9800'
}
```

### Green (MAE)
```javascript
{
    background: '#e8f5e8',
    color: '#2e7d32',
    border: '#c8e6c9',
    borderLeft: '#4caf50'
}
```

### Red (Poor R² / Errors)
```javascript
{
    background: '#ffebee',
    color: '#d32f2f',
    border: '#ffcdd2',
    borderLeft: '#f44336'
}
```

## API Reference

### Constructor

```javascript
new MetricBoxDisplay(elementId, metricName, options)
```

**Parameters:**
- `elementId` (string): ID of the HTML element to update
- `metricName` (string): Name of the metric (e.g., 'MSE', 'MAE', 'R²')
- `options` (object):
  - `background` (string): Background color
  - `color` (string): Text color
  - `border` (string): Border color
  - `borderLeft` (string): Left border color (thicker accent)
  - `label` (string|null): Optional label for bottom-right corner
  - `decimals` (number): Number of decimal places (default: 2)

### Instance Methods

#### `update(value, triggerMathJax = true)`

Update the display with a new value.

**Parameters:**
- `value` (number|string|null): The metric value to display
  - **number**: Formatted with specified decimal places (e.g., `123.45`)
  - **null/undefined**: Shows placeholder "?" (e.g., `MSE = ?`)
  - **string**: Displays as-is (e.g., `'?'` shows `MSE = ?`)
- `triggerMathJax` (boolean): Whether to trigger MathJax rendering (default: true)

**Examples:**
```javascript
mseDisplay.update(123.456);  // Shows "MSE = 123.46"
mseDisplay.update(null);     // Shows "MSE = ?"
mseDisplay.update('?');      // Shows "MSE = ?"
```

### Static Methods

#### `MetricBoxDisplay.batchUpdate(updates)`

Efficiently update multiple displays with a single MathJax render call.

**Parameters:**
- `updates` (Array): Array of `{display, value}` objects

**Example:**
```javascript
MetricBoxDisplay.batchUpdate([
    { display: trainMse, value: 100.5 },
    { display: testMse, value: 250.3 }
]);
```

## Benefits

1. **No CSS Required**: Colors set via JavaScript, no demo-specific CSS classes needed
2. **Consistent Styling**: All boxes use the lec02a template pattern
3. **MathJax Integration**: Automatic MathJax rendering with proper escaping
4. **Performance**: Batch updates minimize MathJax re-renders
5. **Flexibility**: Fully customizable colors, labels, and precision
6. **Maintainability**: Single source of truth for metric display logic

## Complete Example

Here's a complete working example:

**HTML:**
```html
<div class="equation" id="train-mse">MSE = 0.0</div>
<div class="equation" id="test-mse">MSE = 0.0</div>

<script src="../scripts/mse-display.js"></script>
<script src="script.js"></script>
```

**JavaScript (script.js):**
```javascript
let displays;

function init() {
    // Initialize displays
    displays = {
        trainMse: new MetricBoxDisplay('train-mse', 'MSE', {
            background: '#e3f2fd',
            color: '#1976d2',
            border: '#bbdefb',
            borderLeft: '#2196f3',
            label: 'Training Set',
            decimals: 1
        }),
        testMse: new MetricBoxDisplay('test-mse', 'MSE', {
            background: '#fff3e0',
            color: '#f57c00',
            border: '#ffe0b2',
            borderLeft: '#ff9800',
            label: 'Test Set',
            decimals: 1
        })
    };

    // Initial update
    updateMetrics();
}

function updateMetrics() {
    const trainMSE = 8540.6;
    const testMSE = 1200.5;

    MetricBoxDisplay.batchUpdate([
        { display: displays.trainMse, value: trainMSE },
        { display: displays.testMse, value: testMSE }
    ]);
}

init();
```

That's it! No CSS required, fully customizable colors and labels, with MathJax support built in.
